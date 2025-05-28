/**
 * tools_section.js
 * 
 * Ce script charge dynamiquement, via une API Django, la liste des outils (tools)
 * associés à un langage donné, groupés par catégorie, et les affiche dans la section dédiée.
 * 
 * Fonctionnement :
 * - Récupère l'ID du langage depuis l'attribut data-language-id de la section.
 * - Fait une requête AJAX vers l'API /tools/api/by-language/<language_id>/.
 * - Affiche les outils groupés par catégorie, ou un message si aucun outil n'est trouvé.
 * - Gère les erreurs de chargement.
 * 
 * Bonnes pratiques :
 * - JS séparé pour la maintenabilité.
 * - Utilisation de classes CSS pour le ciblage.
 * - Gestion des erreurs et du chargement.
 */

document.addEventListener('DOMContentLoaded', function() {
    // Sélectionne la section outils associée au langage
    const section = document.querySelector('.tools-section');
    if (!section) return; // Si la section n'existe pas, on arrête

    const languageId = section.dataset.languageId;
    const container = section.querySelector('.tools-by-category');

    // Affiche un message de chargement
    container.innerHTML = '<p class="italic text-gray-500">Chargement des outils…</p>';

    // Requête AJAX vers l'API Django
    fetch(`/tools/api/by-language/${languageId}/`)
        .then(response => response.json())
        .then(data => {
            // Si aucun outil n'est trouvé
            if (data.results.length === 0) {
                container.innerHTML = '<p class="italic text-gray-500">Aucun outil associé pour ce langage.</p>';
                return;
            }
            // Génère le HTML pour chaque catégorie et ses outils
            let html = '';
            data.results.forEach(cat => {
                html += `<h3 class="text-xl font-bold mt-6 mb-2">${cat.category}</h3>`;
                html += '<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">';
                cat.tools.forEach(tool => {
                    html += `
                        <article class="card p-6 flex flex-col h-full">
                            <div class="flex-1 flex flex-col justify-between space-y-2">
                                <div>
                                    <h3 class="text-xl font-black text-neo-black mb-1">
                                        <a href="/tools/${tool.id}/" class="hover:underline">${tool.name}</a>
                                    </h3>
                                    <p class="text-gray-700 text-sm mb-2">${tool.description ? tool.description.split(' ').slice(0, 20).join(' ') + '…' : ''}</p>
                                </div>
                                <ul class="text-xs text-neo-black mb-2 space-y-1">
                                    <li><span class="font-bold">Sous-catégories :</span> ${tool.subtypes ? tool.subtypes.join(', ') : ''}</li>
                                    <li><span class="font-bold">Langages :</span> ${tool.languages ? tool.languages.join(', ') : ''}</li>
                                </ul>
                            </div>
                            <div class="pt-2">
                                <a href="/tools/${tool.id}/" class="inline-block px-4 py-2 bg-white border-4 border-black font-black uppercase hover:bg-pokedev-yellow hover:text-black hover:-translate-y-1 transition-all duration-200 shadow-neo">Voir le détail</a>
                            </div>
                        </article>
                    `;
                });
                html += '</div>';
            });
            container.innerHTML = html;
        })
        .catch(() => {
            // Gestion des erreurs réseau ou serveur
            container.innerHTML = '<p class="italic text-red-500">Erreur lors du chargement des outils.</p>';
        });
});