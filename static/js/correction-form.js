document.addEventListener("DOMContentLoaded", () => {
  const fieldSelect = document.getElementById("id_field")
  const currentValueContainer = document.getElementById("current-value-container")
  const currentValueElement = document.getElementById("current-value")

  if (!fieldSelect || !currentValueContainer || !currentValueElement) {
    return
  }

  // Fonction pour récupérer la valeur actuelle du champ
  function fetchCurrentValue(fieldName) {
    if (!fieldName) {
      currentValueContainer.classList.add("hidden")
      return
    }

    const languageSlug = window.location.pathname.split("/")[2] // Récupère le slug depuis l'URL

    fetch(`/languages/api/field-value/${languageSlug}/${fieldName}/`)
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          currentValueElement.textContent = data.value || "Aucune valeur définie"
          currentValueContainer.classList.remove("hidden")
        } else {
          currentValueElement.textContent = "Valeur non disponible"
          currentValueContainer.classList.remove("hidden")
        }
      })
      .catch((error) => {
        console.error("Erreur lors de la récupération de la valeur:", error)
        currentValueElement.textContent = "Erreur lors du chargement"
        currentValueContainer.classList.remove("hidden")
      })
  }

  // Écouter les changements sur le menu déroulant
  fieldSelect.addEventListener("change", function () {
    fetchCurrentValue(this.value)
  })
})
