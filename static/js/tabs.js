document.addEventListener('DOMContentLoaded', function() {
    // ===== FONCTIONS COMMUNES =====
    
    // Fonction pour initialiser les onglets
    function initTabs(tabButtons, tabContents) {
        // Cacher tous les contenus sauf le premier au chargement
        tabContents.forEach((content, index) => {
            if (index !== 0) {
                content.style.display = 'none';
            }
        });
        
        tabButtons.forEach(button => {
            button.addEventListener('click', function() {
                const targetId = this.getAttribute('data-target');
                
                // Masquer tous les contenus
                tabContents.forEach(content => {
                    content.style.display = 'none';
                });
                
                // Afficher le contenu ciblé
                const targetContent = document.getElementById(targetId);
                if (targetContent) {
                    targetContent.style.display = 'block';
                }
                
                // Mettre à jour les styles des boutons
                tabButtons.forEach(btn => {
                    btn.classList.remove('active');
                    btn.classList.remove('bg-black');
                    btn.classList.remove('text-white');
                    btn.classList.add('bg-white');
                    btn.classList.add('text-black');
                });
                
                this.classList.add('active');
                this.classList.remove('bg-white');
                this.classList.remove('text-black');
                this.classList.add('bg-black');
                this.classList.add('text-white');
            });
        });
    }
    
    // ===== ONGLETS DES CARACTÉRISTIQUES =====
    const featureTabButtons = document.querySelectorAll('.feature-tab-btn');
    const featureTabContents = document.querySelectorAll('.feature-tab-content');
    
    if (featureTabButtons.length > 0 && featureTabContents.length > 0) {
        initTabs(featureTabButtons, featureTabContents);
    }
    
    // ===== ONGLETS D'ACCESSIBILITÉ =====
    
    // Appliquer les couleurs aux badges de niveau
    document.querySelectorAll('[data-level-number]').forEach(function(element) {
        var levelNumber = parseInt(element.getAttribute('data-level-number'));
        if (levelNumber <= 2) {
            element.classList.add('bg-green-400');
        } else if (levelNumber <= 4) {
            element.classList.add('bg-yellow-400');
        } else {
            element.classList.add('bg-red-400');
        }
    });
    
    // Initialiser les onglets de niveaux
    const levelTabButtons = document.querySelectorAll('.level-tab-btn');
    const levelTabContents = document.querySelectorAll('.level-tab-content');
    
    if (levelTabButtons.length > 0 && levelTabContents.length > 0) {
        initTabs(levelTabButtons, levelTabContents);
    }
});