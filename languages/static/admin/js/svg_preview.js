// Fonction pour prévisualiser le SVG
function previewSVG() {
  const svgField = document.getElementById("id_logo_svg")
  if (!svgField) return

  const svgCode = svgField.value
  let previewDiv = document.getElementById("svg-preview")

  if (!previewDiv) {
    previewDiv = document.createElement("div")
    previewDiv.id = "svg-preview"
    previewDiv.className = "svg-preview"

    const fieldWrapper = svgField.closest(".field-logo_svg")
    if (fieldWrapper) {
      fieldWrapper.appendChild(previewDiv)
    } else {
      svgField.parentNode.appendChild(previewDiv)
    }
  }

  previewDiv.innerHTML = svgCode
}

// Initialisation lorsque le DOM est chargé
document.addEventListener("DOMContentLoaded", () => {
  // Ajouter un bouton de prévisualisation pour le champ logo_svg
  const svgField = document.getElementById("id_logo_svg")
  if (svgField) {
    // Créer un div pour la prévisualisation s'il n'existe pas déjà
    if (!document.getElementById("svg-preview")) {
      const previewDiv = document.createElement("div")
      previewDiv.id = "svg-preview"
      previewDiv.className = "svg-preview"

      const fieldWrapper = svgField.closest(".field-logo_svg")
      if (fieldWrapper) {
        fieldWrapper.appendChild(previewDiv)
      } else {
        svgField.parentNode.appendChild(previewDiv)
      }
    }

    // Prévisualiser automatiquement si un SVG existe déjà
    if (svgField.value) {
      previewSVG()
    }

    // Mettre à jour la prévisualisation lors de la modification du champ
    svgField.addEventListener("input", () => {
      previewSVG()
    })
  }

  // Ajouter des liens supplémentaires dans l'interface
  const additionalLinks = document.querySelectorAll(".additional-links a")
  additionalLinks.forEach((link) => {
    link.addEventListener("click", function (e) {
      if (this.getAttribute("target") !== "_blank") {
        e.preventDefault()
        const url = this.getAttribute("href")
        window.location.href = url
      }
    })
  })
})
