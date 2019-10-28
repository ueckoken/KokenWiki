import React from 'react'
import marked from 'marked';
import * as escape from 'escape-html';
import { connect } from 'react-redux';
import { mapStateToProps, mapDispatchToProps} from "./connector";
import hljs from 'highlight.js';
import 'highlight.js/styles/vs.css';
//hljs.configure({useBR: true});
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
export class Markdown extends React.Component {
    constructor(props) {
        
        marked.setOptions({
            gfm: true,
            tables: true,
            breaks: true,
            pedantic: false,
            sanitize: true,
            smartLists: true,
            smartypants: false,
            langPrefix: '',
        });
        super(props);
        this.myRef = React.createRef();
    }
    componentDidMount() {
      //this.updateCodeSyntaxHighlighting();
    }
  
    componentDidUpdate() {
      //this.updateCodeSyntaxHighlighting();
    }
  
    updateCodeSyntaxHighlighting = () => {
        if(!this.props.highlight){return;}
        this.myRef.current.querySelectorAll("pre code").forEach(block => {
            hljs.highlightBlock(block);
        });
    };
  
    render() {
        const html = marked((this.props.markdown))
        return (
            <div ref={this.myRef} className="" dangerouslySetInnerHTML={{
                __html: html
            }}>
            </div>);
    }
};
function html_escape(str) {
    if (!str) return "";
    return str.replace(/[<>&"'`]/g, function(match) {
      const escape = {
        '<': '&lt;',
        '>': '&gt;',
        '&': '&amp;',
        '"': '&quot;',
        "'": '&#39;',
        '`': '&#x60;'
      };
      return escape[match];
    });
}

function amp_escape(str) {
    if (!str) return "";
    return str.replace(/[&]/g, function(match) {
      const escape = {
        '&': '&amp;',
      };
      return escape[match];
    });
}
export default connect(mapStateToProps, mapDispatchToProps)(Markdown);