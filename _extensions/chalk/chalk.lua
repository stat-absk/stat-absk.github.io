-- The site's marks as shortcodes.
--
--   {{< tally 15 >}}   a count in gates of five; the number is there as text,
--                      the strokes are hidden from assistive technology.
--   {{< rule >}}       one chalk rule, the next stroke from the set of eight,
--                      so neighbouring rules never match.
--
-- The strokes live in marks/chalk.svg; the chalk roughening is the page's
-- #chalk filter, applied by _marks.scss.

local SPRITE = "/marks/chalk.svg"
local rule_n = 0

local function stroke(x)
  return string.format('<use href="%s#stroke" x="%d" y="0" width="12" height="40"/>', SPRITE, x)
end

-- One gate: up to four uprights and, at five, the strike through them.
local function gate(k)
  local parts = {}
  for i = 1, math.min(k, 4) do parts[#parts + 1] = stroke(2 + (i - 1) * 13) end
  if k == 5 then parts[#parts + 1] = string.format('<use href="%s#strike" x="0" y="0" width="60" height="40"/>', SPRITE) end
  local width = (k >= 4) and 60 or (2 + k * 13)
  return string.format('<svg viewBox="0 0 %d 40" aria-hidden="true" focusable="false">%s</svg>', width, table.concat(parts))
end

return {
  ["tally"] = function(args, kwargs, meta)
    local n = tonumber(pandoc.utils.stringify(args[1] or "")) or 0
    local gates, left = {}, n
    while left > 0 do
      local k = math.min(left, 5)
      gates[#gates + 1] = gate(k)
      left = left - k
    end
    local html = string.format(
      '<span class="tally" role="img" aria-label="%d"><span class="visually-hidden">%d</span>%s</span>',
      n, n, table.concat(gates))
    return pandoc.RawInline("html", html)
  end,

  ["rule"] = function(args, kwargs, meta)
    rule_n = rule_n % 8 + 1
    return pandoc.RawBlock("html",
      string.format('<div class="chalk-rule" data-rule="%d" aria-hidden="true"></div>', rule_n))
  end,
}
