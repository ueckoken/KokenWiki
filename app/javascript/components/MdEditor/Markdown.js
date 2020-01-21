import React, { useEffect } from 'react'
import marked from 'marked';
import * as escape from 'escape-html';
import sanitizeHtml from 'sanitize-html';
import { connect } from 'react-redux';
marked.Parser.prototype.parse = function(src) {
    this.inline = new marked.InlineLexer(src.links, this.options)
    this.inlineText = new marked.InlineLexer(
        src.links,
        Object.assign({}, this.options, { renderer: new marked.TextRenderer() })
    )

    let link = this.inline.rules.link.source
    let text = this.inline.rules.text.source

    this.inline.rules.link = new RegExp(link.replace(/\^!\?/, '^[!?$]?'))
    this.inline.rules.text = new RegExp(text.replace(/<!\\\[/, '<!?\\['))

    this.tokens = src.reverse()

    let out = ''
    while (this.next()) out += this.tok()

    return out
}

marked.InlineLexer.prototype.outputLink = function(cap, link) {
    const href = link.href
    const title = link.title ? escape(link.title) : null

    switch (cap[0].charAt(0)) {
    case '?': 
        return this.renderer.video(href, title, escape(cap[1]))
    case '!':
        return this.renderer.image(href, title, escape(cap[1]))
    case '$':
        return this.renderer.audio(href, escape(cap[1]))
    default:
        return this.renderer.link(href, title, this.output(cap[1]))
    }
}

marked.Renderer.prototype.video = function (href, title, alt) {
    if (href.search(/^javascript:/)>=0){
        return alt
    }else{
        const isNumber = function(value) {
          return ((typeof value === 'number') && (isFinite(value)));
        };
        let size=""
        if (title&&title.length>=1){                                                                                                
            let size_ = title.split('x');
            if (size_.length==2) {
                                                                                                                                                          
                if (isNumber(Number.parseInt(size_[0]))){                                                                                                       
                    size += 'width="' + size_[0]+`"`;
                }
                if (isNumber(Number.parseInt(size_[1]))) {                                                                                          
                    size += ' height="' + size_[1]+`"`;
                }
            } else {
                size=""                                                                                 
            }                                                                                                                     
        } else {                                                                                                                  
            size = '';                                                                                                            
        }                    
        return `<video src="${href}" `+ size +`controls>${alt}</video>`
    }
}

marked.Renderer.prototype.audio = function (href, alt) {
    if (href.search(/^javascript:/)>=0){
        return alt
    }else{
        return `<audio src="${href}" controls>${alt}</audio>`
    }
}
marked.Renderer.prototype.image = function(href, title, text) {  
    if (href.search(/^javascript:/)>=0){
        return alt
    }
    const isNumber = function(value) {
      return ((typeof value === 'number') && (isFinite(value)));
    };
    let size=""
    if (title&&title.length>=1){                                                                                                
        let size_ = title.split('x');
        if (size_.length==2) {
                                                                                                                                                      
            if (isNumber(Number.parseInt(size_[0]))){                                                                                                       
                size += 'width=' + size_[0];
            }
            if (isNumber(Number.parseInt(size_[1]))) {                                                                                          
                size += ' height=' + size_[1];
            }
        } else {
            size=""                                                                                 
        }                                                                                                                     
    } else {                                                                                                                  
        size = '';                                                                                                            
    }                                                                                                                         
    return ('<img src="' + href + '" alt="' + text + '" ' + size + '>');                                                      
};


export const Markdown = ({ markdown }) => {
    useEffect(() => {
        marked.setOptions({
            gfm: true,
            tables: true,
            breaks: true,
            pedantic: false,
            sanitize: false,
            smartLists: true,
            smartypants: false,
            langPrefix: '',
        });
    }, []);

    let html = marked(markdown)
    html = sanitizeHtml(html,{
        allowedTags: [ 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'p', 'a', 'ul', 'ol',
        'nl', 'li', 'b', 'i', 'strong', 'em', 'strike', 'code', 'hr', 'br', 'div',
        'table', 'thead', 'caption', 'tbody', 'tr', 'th', 'td', 'pre', 'summary', 'details', 'span', 'img', 'video', 'audio'],
        disallowedTagsMode: 'escape',
        allowedSchemes: [ 'http', 'https' ],
        allowedAttributes: {
            '*': ["style"],
            a: ["href"],
            img: ["src", "width", "height"],
            video: ["src", "width", "height", "controls"],
            audio: ["src", "controls"],
            table: ["class"],
        },
        allowedStyles: {
            '*': {
              // Match HEX and RGB
              'color': [/^#(0x)?[0-9a-f]+$/i, /^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/],
              'background-color': [/^#(0x)?[0-9a-f]+$/i, /^rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/],
              'text-align': [/^left$/, /^right$/, /^center$/],
              // Match any number with px, em, or %
              'font-size': [/^\d+(?:px|em|%)$/]
            },
        },
        
        allowedClasses: {
            table: [ 'table', 'table-hober' ],
        },
        transformTags: {
            table: sanitizeHtml.simpleTransform('table', {class: 'table table-hober'}),
        },

    })
    return (
        /*<div className="markdown-body">
            <iframe srcdoc={html} width="100%" height="100%" sandbox="allow-same-origin allow-top-navigation-by-user-activation"/>
        </div>*/
        //iframe で制限強めようとしてheight可変わからん
        <div className="markdown-body" dangerouslySetInnerHTML={{
            __html: html
        }}>
        </div>
    );
};

export default connect(state => ({
    markdown: state.markdown
}), null)(Markdown);