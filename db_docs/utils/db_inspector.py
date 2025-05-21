# db_docs/utils/db_inspector.py
from django.db import connection

def get_database_info():
    """Récupère des informations sur la base de données"""
    schemas = []
    tables = []
    
    with connection.cursor() as cursor:
        # Récupérer les schémas
        cursor.execute("""
            SELECT schema_name, schema_owner
            FROM information_schema.schemata
            WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
            ORDER BY schema_name
        """)
        for row in cursor.fetchall():
            schemas.append({
                'name': row[0],
                'owner': row[1]
            })
        
        # Récupérer les tables
        cursor.execute("""
            SELECT 
                table_schema, 
                table_name, 
                table_type
            FROM 
                information_schema.tables
            WHERE 
                table_schema NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
            ORDER BY 
                table_schema, table_name
        """)
        for row in cursor.fetchall():
            tables.append({
                'schema': row[0],
                'name': row[1],
                'type': row[2]
            })
    
    return {
        'schemas': schemas,
        'tables': tables
    }

def get_table_details(schema_name, table_name):
    """Récupère les détails d'une table spécifique"""
    columns = []
    constraints = []
    indexes = []
    
    with connection.cursor() as cursor:
        # Récupérer les colonnes
        cursor.execute("""
            SELECT 
                column_name, 
                data_type, 
                is_nullable, 
                column_default,
                character_maximum_length
            FROM 
                information_schema.columns
            WHERE 
                table_schema = %s AND table_name = %s
            ORDER BY 
                ordinal_position
        """, [schema_name, table_name])
        
        for row in cursor.fetchall():
            columns.append({
                'name': row[0],
                'type': row[1],
                'nullable': row[2] == 'YES',
                'default': row[3],
                'max_length': row[4]
            })
        
        # Récupérer les contraintes (PostgreSQL)
        try:
            cursor.execute("""
                SELECT 
                    conname AS constraint_name,
                    contype AS constraint_type,
                    pg_get_constraintdef(c.oid) AS constraint_definition
                FROM 
                    pg_constraint c
                JOIN 
                    pg_namespace n ON n.oid = c.connamespace
                JOIN 
                    pg_class cl ON cl.oid = c.conrelid
                WHERE 
                    n.nspname = %s AND cl.relname = %s
            """, [schema_name, table_name])
            
            for row in cursor.fetchall():
                constraint_type = {
                    'p': 'PRIMARY KEY',
                    'u': 'UNIQUE',
                    'f': 'FOREIGN KEY',
                    'c': 'CHECK'
                }.get(row[1], row[1])
                
                constraints.append({
                    'name': row[0],
                    'type': constraint_type,
                    'definition': row[2]
                })
        except:
            # Si ce n'est pas PostgreSQL ou si la requête échoue
            pass
        
        # Récupérer les index (PostgreSQL)
        try:
            cursor.execute("""
                SELECT
                    i.relname AS index_name,
                    am.amname AS index_type,
                    pg_get_indexdef(i.oid) AS index_definition
                FROM
                    pg_index x
                JOIN
                    pg_class i ON i.oid = x.indexrelid
                JOIN
                    pg_class t ON t.oid = x.indrelid
                JOIN
                    pg_namespace n ON n.oid = t.relnamespace
                JOIN
                    pg_am am ON am.oid = i.relam
                WHERE
                    n.nspname = %s AND t.relname = %s
            """, [schema_name, table_name])
            
            for row in cursor.fetchall():
                indexes.append({
                    'name': row[0],
                    'type': row[1],
                    'definition': row[2]
                })
        except:
            # Si ce n'est pas PostgreSQL ou si la requête échoue
            pass
    
    return {
        'columns': columns,
        'constraints': constraints,
        'indexes': indexes
    }
