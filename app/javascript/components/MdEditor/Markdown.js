import React from 'react'
import marked from 'marked';
import * as escape from 'escape-html';
import { connect } from 'react-redux';
import { mapStateToProps, mapDispatchToProps} from "./connector";
import hljs from 'highlight.js';
import 'highlight.js/styles/vs.css';
//hljs.configure({useBR: true});
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
      this.updateCodeSyntaxHighlighting();
    }
  
    componentDidUpdate() {
      this.updateCodeSyntaxHighlighting();
    }
  
    updateCodeSyntaxHighlighting = () => {
        if(!this.props.highlight){return;}
        this.myRef.current.querySelectorAll("pre code").forEach(block => {
            hljs.highlightBlock(block);
        });
    };
  
    render() {
        const html = marked(amp_escape(this.props.markdown))
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