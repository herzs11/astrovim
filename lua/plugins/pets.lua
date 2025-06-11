return {
  "giusgad/pets.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "edluffy/hologram.nvim" },
  opts = {
    death_animation = false,
    popup = {
      width = "10%",
    },
  },
  cmd = { "PetsNew", "PetsNewCustom" },
}
