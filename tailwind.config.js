module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/views/**/*.html.haml',
    './app/views/**/*.turbo_stream.erb',
    './app/views/**/*.turbo_stream.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/components/**/*.html.haml',
    './app/components/**/*.rb',
  ],
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      charcoal2: '#0a0f12',
      charcoal22: '#0f1316',
      onyx: '#303536',

      /* focus config: make it smaller, and light-blue */
      "wa-focus": 'var(--focus-color)',

      /* surface config: blue-tinted dark */
      "wa-surface-default": 'var(--color-surface-default)',
      "wa-surface-raised": 'var(--color-surface-raised)',
      "wa-surface-lowered": '#0a1117',
      "wa-surface-border": 'var(--color-surface-border)',

      /* text-color config: blue-tinted white-ish */
      "wa-text-normal": '#eaeaff',
      "wa-text-quiet": '#5f5f67',
      "wa-text-link": 'var(--color-text-link)',

      /* color config */
      /*** brand color ***/
      "wa-brand-fill-quiet": 'var(--color-brand-fill-quiet)',
      "wa-brand-fill-normal": 'var(--color-brand-fill-normal)',
      "wa-brand-fill-loud": 'var(--color-brand-fill-loud)',

      "wa-brand-border-quiet": 'var(--color-brand-border-quiet)',
      "wa-brand-border-normal": 'var(--color-brand-border-normal)',
      "wa-brand-border-loud": 'var(--color-brand-border-loud)',

      "wa-brand-on-quiet": 'var(--color-brand-on-quiet)',
      "wa-brand-on-normal": 'var(--color-brand-on-normal)',
      "wa-brand-on-loud": 'var(--color-brand-on-loud)',

      /*** success color ***/
      "wa-success-fill-quiet": '#728964',
      "wa-success-fill-normal": 'var(--color-success-fill-normal)',
      "wa-success-fill-loud": 'var(--color-success-fill-loud)',

      "wa-success-border-quiet": 'var(--color-success-border-quiet)',
      "wa-success-border-normal": 'var(--color-success-border-normal)',
      "wa-success-border-loud": 'var(--color-success-border-loud)',

      "wa-success-on-quiet": 'var(--color-success-on-quiet)',
      "wa-success-on-normal": 'var(--color-success-on-normal)',
      "wa-success-on-loud": 'var(--color-success-on-loud)',

      /*** neutral color ***/
      "wa-neutral-fill-quiet": 'var(--color-neutral-fill-quiet)',
      "wa-neutral-fill-normal": 'var(--color-neutral-fill-normal)',
      "wa-neutral-fill-loud": 'var(--color-neutral-fill-loud)',

      "wa-neutral-border-quiet": 'var(--color-neutral-border-quiet)',
      "wa-neutral-border-normal": 'var(--color-neutral-border-normal)',
      "wa-neutral-border-loud": 'var(--color-neutral-border-loud)',

      "wa-neutral-on-quiet": 'var(--color-neutral-on-quiet)',
      "wa-neutral-on-normal": 'var(--color-neutral-on-normal)',
      "wa-neutral-on-loud": 'var(--color-neutral-on-loud)',

      /*** warning color ***/
      "wa-warning-fill-quiet": 'var(--color-warning-fill-quiet)',
      "wa-warning-fill-normal": 'var(--color-warning-fill-normal)',
      "wa-warning-fill-loud": 'var(--color-warning-fill-loud)',

      "wa-warning-border-quiet": 'var(--color-warning-border-quiet)',
      "wa-warning-border-normal": 'var(--color-warning-border-normal)',
      "wa-warning-border-loud": 'var(--color-warning-border-loud)',

      "wa-warning-on-quiet": 'var(--color-warning-on-quiet)',
      "wa-warning-on-normal": 'var(--color-warning-on-normal)',
      "wa-warning-on-loud": 'var(--color-warning-on-loud)',

      /*** warning color ***/
      "wa-danger-fill-quiet2": 'var(--color-danger-fill-quiet2)',
      "wa-danger-fill-quiet": 'var(--color-danger-fill-quiet)',
      "wa-danger-fill-normal": 'var(--color-danger-fill-normal)',
      "wa-danger-fill-loud": 'var(--color-danger-fill-loud)',

      "wa-danger-border-quiet": 'var(--color-danger-border-quiet)',
      "wa-danger-border-normal": 'var(--color-danger-border-normal)',
      "wa-danger-border-loud": 'var(--color-danger-border-loud)',

      "wa-danger-on-quiet": 'var(--color-danger-on-quiet)',
      "wa-danger-on-normal": 'var(--color-danger-on-normal)',
      "wa-danger-on-loud": 'var(--color-danger-on-loud)',
    },
    borderRadius: {
      'none': '0',
      'sm': 'calc(.1875 * .5rem)',
      DEFAULT: 'calc(.1875 * 1rem)',
      'md': 'calc(.1875 * 2rem)',
      'lg': 'calc(.1875 * 3rem)',
      'full': '9999px',
    },
    extend: {
      animation: {
        'opacity-appear': 'opacity-appear .86s cubic-bezier(0.16, 1, 0.3, 1) forwards',
        'opacity-disappear': 'opacity-disappear .86s cubic-bezier(0.7, 0, 0.84, 0) forwards',
        'shake': 'shake .7s cubic-bezier(0.37, 0, 0.63, 1) forwards',
        'text-quietize': 'text-quietize .3s ease-out',
        'text-normalize': 'text-normalize .3s ease-out',
        'flash': 'flash-slide-reverse .7s cubic-bezier(0.65, 0, 0.35, 1)',
        'flash-out': 'flash-slide .7s cubic-bezier(0.65, 0, 0.35, 1) forwards',
        'sidebar': 'sidebar-slide .86s cubic-bezier(0.33, 1, 0.68, 1)',
        'sidebar-out': 'sidebar-slide-reverse .86s cubic-bezier(0.33, 1, 0.68, 1) forwards',
        'sidebar-slide': {
          from: {
            opacity: '0%',
            transform: 'translateX(100%)'
          },
          to: {
            opacity: '100%',
            transform: 'translateX(0)'
          }
        },
      },
      keyframes: {
        'opacity-appear': {
          from: { opacity: 0 },
        },
        'opacity-disappear': {
          to: { opacity: 0 },
        },
        'shake': {
          '0%': { transform: 'translateX(0)' },
          '25%': { transform: 'translateX(-2%)' },
          '50%': { transform: 'translateX(3%)' },
          '75%': { transform: 'translateX(-2%)' },
          '100%': { transform: 'translateX(0)' },
        },
        'text-quietize': {
          '0%': { color: 'theme(colors.wa-text-normal)' },
          '100%': { color: 'theme(colors.wa-text-quiet)' },
        },
        'text-normalize': {
          '0%': { color: 'theme(colors.wa-text-quiet)' },
          '100%': { color: 'theme(colors.wa-text-normal)' },
        },
        'sidebar-slide': {
          from: {
            opacity: '0%',
            transform: 'translateX(100%)'
          },
          to: {
            opacity: '100%',
            transform: 'translateX(0)'
          }
        },
        'sidebar-slide-reverse': {
          from: {
            opacity: '100%',
            transform: 'translateX(0)'
          },
          to: {
            opacity: '0%',
            transform: 'translateX(100%)'
          }
        },
        'flash-slide': {
          from: {
            opacity: '100%',
            transform: 'translateY(0px)'
          },
          to: {
            opacity: '0%',
            transform: 'translateY(-100%)'
          }
        },
        'flash-slide-reverse': {
          from: {
            opacity: '0%',
            transform: 'translateY(-100%)'
          },
          to: {
            opacity: '100%',
            transform: 'translateY(0px)'
          }
        },
      }
    }
  },
  plugins: [
    require('@tailwindcss/typography'),
    require("@xpd/tailwind-3dtransforms")
  ]
}
