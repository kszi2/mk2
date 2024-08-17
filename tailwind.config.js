module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.haml',
    './app/views/**/*.turbo_stream.erb',
    './app/views/**/*.turbo_stream.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      charcoal2: '#0a0f12',
      charcoal22: '#0f1316',
      onyx: '#303536',

      /* focus config: make it smaller, and light-blue */
      "wa-focus": 'var(--wa-focus-color)',

      /* surface config: blue-tinted dark */
      "wa-surface-default": 'var(--wa-color-surface-default)',
      "wa-surface-raised": 'var(--wa-color-surface-raised)',
      "wa-surface-lowered": 'var(--wa-color-surface-lowered)',
      "wa-surface-border": 'var(--wa-color-surface-border)',

      /* text-color config: blue-tinted white-ish */
      "wa-text-normal": 'var(--wa-color-text-normal)',
      "wa-text-quiet": 'var(--wa-color-text-quiet)',
      "wa-text-link": 'var(--wa-color-text-link)',

      /* color config */
      /*** brand color ***/
      "wa-brand-fill-quiet": 'var(--wa-color-brand-fill-quiet)',
      "wa-brand-fill-normal": 'var(--wa-color-brand-fill-normal)',
      "wa-brand-fill-loud": 'var(--wa-color-brand-fill-loud)',

      "wa-brand-border-quiet": 'var(--wa-color-brand-border-quiet)',
      "wa-brand-border-normal": 'var(--wa-color-brand-border-normal)',
      "wa-brand-border-loud": 'var(--wa-color-brand-border-loud)',

      "wa-brand-on-quiet": 'var(--wa-color-brand-on-quiet)',
      "wa-brand-on-normal": 'var(--wa-color-brand-on-normal)',
      "wa-brand-on-loud": 'var(--wa-color-brand-on-loud)',

      /*** success color ***/
      "wa-success-fill-quiet": 'var(--wa-color-success-fill-quiet)',
      "wa-success-fill-normal": 'var(--wa-color-success-fill-normal)',
      "wa-success-fill-loud": 'var(--wa-color-success-fill-loud)',

      "wa-success-border-quiet": 'var(--wa-color-success-border-quiet)',
      "wa-success-border-normal": 'var(--wa-color-success-border-normal)',
      "wa-success-border-loud": 'var(--wa-color-success-border-loud)',

      "wa-success-on-quiet": 'var(--wa-color-success-on-quiet)',
      "wa-success-on-normal": 'var(--wa-color-success-on-normal)',
      "wa-success-on-loud": 'var(--wa-color-success-on-loud)',

      /*** neutral color ***/
      "wa-neutral-fill-quiet": 'var(--wa-color-neutral-fill-quiet)',
      "wa-neutral-fill-normal": 'var(--wa-color-neutral-fill-normal)',
      "wa-neutral-fill-loud": 'var(--wa-color-neutral-fill-loud)',

      "wa-neutral-border-quiet": 'var(--wa-color-neutral-border-quiet)',
      "wa-neutral-border-normal": 'var(--wa-color-neutral-border-normal)',
      "wa-neutral-border-loud": 'var(--wa-color-neutral-border-loud)',

      "wa-neutral-on-quiet": 'var(--wa-color-neutral-on-quiet)',
      "wa-neutral-on-normal": 'var(--wa-color-neutral-on-normal)',
      "wa-neutral-on-loud": 'var(--wa-color-neutral-on-loud)',

      /*** warning color ***/
      "wa-warning-fill-quiet": 'var(--wa-color-warning-fill-quiet)',
      "wa-warning-fill-normal": 'var(--wa-color-warning-fill-normal)',
      "wa-warning-fill-loud": 'var(--wa-color-warning-fill-loud)',

      "wa-warning-border-quiet": 'var(--wa-color-warning-border-quiet)',
      "wa-warning-border-normal": 'var(--wa-color-warning-border-normal)',
      "wa-warning-border-loud": 'var(--wa-color-warning-border-loud)',

      "wa-warning-on-quiet": 'var(--wa-color-warning-on-quiet)',
      "wa-warning-on-normal": 'var(--wa-color-warning-on-normal)',
      "wa-warning-on-loud": 'var(--wa-color-warning-on-loud)',

      /*** warning color ***/
      "wa-danger-fill-quiet2": 'var(--wa-color-danger-fill-quiet2)',
      "wa-danger-fill-quiet": 'var(--wa-color-danger-fill-quiet)',
      "wa-danger-fill-normal": 'var(--wa-color-danger-fill-normal)',
      "wa-danger-fill-loud": 'var(--wa-color-danger-fill-loud)',

      "wa-danger-border-quiet": 'var(--wa-color-danger-border-quiet)',
      "wa-danger-border-normal": 'var(--wa-color-danger-border-normal)',
      "wa-danger-border-loud": 'var(--wa-color-danger-border-loud)',

      "wa-danger-on-quiet": 'var(--wa-color-danger-on-quiet)',
      "wa-danger-on-normal": 'var(--wa-color-danger-on-normal)',
      "wa-danger-on-loud": 'var(--wa-color-danger-on-loud)',
    },
    borderRadius: {
      'none': '0',
      'sm': 'var(--wa-border-radius-xs)',
      DEFAULT: 'var(--wa-border-radius-s)',
      'md': 'var(--wa-border-radius-m)',
      'lg': 'var(--wa-border-radius-l)',
      'full': 'var(--wa-border-radius-pill)',
    },
    extend: {
      spacing: {
        '2full': '200%',
      }
    }
  },
  plugins: [
    require('@tailwindcss/typography'),
    require("@xpd/tailwind-3dtransforms")
  ]
}
