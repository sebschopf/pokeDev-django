const tailwind = {
  config: {},
}

// Configuration pour que Tailwind n'écrase pas les styles personnalisés
tailwind.config = {
  important: false, // Permet aux styles CSS de prévaloir
  theme: {
    extend: {
      colors: {
        primary: "#f5d413",
        dark: "#111",
      },
      fontFamily: {
        sans: ["Roboto", "sans-serif"],
      },
    },
  },
}
