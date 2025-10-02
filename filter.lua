--[[
  This Pandoc Lua Filter performs two main tasks:
  1. Adds lazy loading to all images
  2. Wraps content in <section> elements at H1 headers and horizontal rules
--]]

local pandoc = pandoc

---Closes the current section and adds it to the blocks list
local function close_section(blocks, current_section, current_id)
  if #current_section > 0 then
    -- The "section" class forces the HTML5 formatter to emit <section> tags
    local section_div = pandoc.Div(current_section, pandoc.Attr(current_id, { "section" }))
    blocks:insert(section_div)
  end
  return pandoc.List()
end

return {
  {
    -- Add lazy loading attribute to all images
    Image = function(img)
      local attrs = img.attributes
      img.attributes.loading = "lazy"
      -- Set aspect ratio for CSS.
      if attrs.width and attrs.height then
        attrs.style = string.format("--aspect-ratio: %.3f", tonumber(attrs.width) / tonumber(attrs.height))
      end
      return img
    end,

    -- Break document into sections at H1 headers and horizontal rules
    Pandoc = function(doc)
      local blocks = pandoc.List()
      local current_section = pandoc.List()
      local current_id = ""

      for _, block in ipairs(doc.blocks) do
        if block.tag == "HorizontalRule" then
          current_section = close_section(blocks, current_section, current_id)
          current_id = current_id .. "~"
        elseif block.tag == "Header" and block.level == 1 then
          current_section = close_section(blocks, current_section, current_id)
          -- Move identifier from header to div wrapper.
          -- This ensures the HTML5 formatter emits the div.
          current_id = block.attr.identifier
          block.attr.identifier = ""
          current_section:insert(block)
        else
          current_section:insert(block)
        end
      end
      close_section(blocks, current_section, current_id)
      return pandoc.Pandoc(blocks, doc.meta)
    end,
  },
}
