require "commonmarker"

module MarkdownHelper
  class PlainTextRenderer < CommonMarker::Renderer
    def header(node)
      block do
        out(:children)
      end
      out("\n")
    end

    def paragraph(node)
      block do
        out(:children)
      end
      out("\n")
    end

    def list(node)
      block do
        out(:children)
      end
    end

    def list_item(node)
      block do
        out(:children)
      end
    end

    def blockquote(node)
      block do
        out(:children)
      end
    end

    def hrule(node)
      block do
        out("\n")
      end
    end

    def code_block(node)
      block do
        out(escape_html(node.string_content))
      end
      out("\n")
    end

    def html(_)
      # drop raw HTML
    end

    def inline_html(_)
      # drop raw HTML
    end

    def emph(_)
      out(:children)
    end

    def strong(_)
      out(:children)
    end

    def link(node)
      out(:children)
    end

    def image(node)
      plain do
        out(:children)
      end
    end

    def text(node)
      out(escape_html(node.string_content))
    end

    def code(node)
      out(escape_html(node.string_content))
    end

    def linebreak(_node)
      out("\n")
    end

    def softbreak(_)
      out("\n")
    end

    def table(_)
      out(:children)
    end

    def table_header(_)
      out(:children)
    end

    def table_row(_)
      block do
        out(:children)
      end
    end

    def table_cell(_)
      out(:children)
      out("、")
    end

    def strikethrough(_)
      out(:children)
    end
  end

  def render_plain_text(doc)
    return plain_text_renderer.render(doc)
  end

  private
    def plain_text_renderer
      @plain_text_renderer ||= PlainTextRenderer.new
      return @plain_text_renderer
    end
end
