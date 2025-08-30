module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/javascript/**/*.{js,ts,jsx,tsx}",
    '!./app/javascript/**/*.test.{tsx, ts}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
