# frozen_string_literal: true

class TabviewComponent < ViewComponent::Base
  renders_many :pages, TabpageComponent

  def titles
    pages.map(&:title)
  end

  private

  def title_classes(pid)
    logger.error("tabview: title_classes(pid): #{pid} is greater than preconfigured values") unless pid.in? KnownPidValues
    "rounded-t px-4 py-2 border-wa-neutral-border-normal border-t-4 border-x border-b" +
      " bg-wa-surface-default hover:bg-wa-surface-raised active:bg-wa-surface-lowered" +
      " group-[[data-tabview-component-activeid-value='#{pid}']]/tabview:border-t-wa-brand-border-loud" +
      " group-[[data-tabview-component-activeid-value='#{pid}']]/tabview:border-b-0" +
      " group-[[data-tabview-component-activeid-value='#{pid}']]/tabview:bg-wa-neutral-fill-quiet"
  end

  def unhide_classes(pid)
    logger.error("tabview: unhide_classes(pid): #{pid} is greater than preconfigured values") unless pid.in? KnownPidValues
    "group-[[data-tabview-component-activeid-value='#{pid}']]/tabview:block"
  end

  KnownPidValues = 0..9
  KnownPids = %W[
group-[[data-tabview-component-activeid-value='0']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='0']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='0']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='0']]/tabview:block
group-[[data-tabview-component-activeid-value='1']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='1']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='1']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='1']]/tabview:block
group-[[data-tabview-component-activeid-value='2']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='2']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='2']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='2']]/tabview:block
group-[[data-tabview-component-activeid-value='3']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='3']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='3']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='3']]/tabview:block
group-[[data-tabview-component-activeid-value='4']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='4']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='4']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='4']]/tabview:block
group-[[data-tabview-component-activeid-value='5']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='5']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='5']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='5']]/tabview:block
group-[[data-tabview-component-activeid-value='6']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='6']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='6']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='6']]/tabview:block
group-[[data-tabview-component-activeid-value='7']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='7']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='7']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='7']]/tabview:block
group-[[data-tabview-component-activeid-value='8']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='8']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='8']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='8']]/tabview:block
group-[[data-tabview-component-activeid-value='9']]/tabview:border-t-wa-brand-border-loud
group-[[data-tabview-component-activeid-value='9']]/tabview:border-b-0
group-[[data-tabview-component-activeid-value='9']]/tabview:bg-wa-neutral-fill-quiet
group-[[data-tabview-component-activeid-value='9']]/tabview:block
]
end
