import React from 'react'
import marked from 'marked';
import * as escape from 'escape-html';
import { connect } from 'react-redux';
import { mapStateToProps, mapDispatchToProps} from "./connector";
export class Markdown extends React.Component {
    constructor(props) {
        marked.setOptions({
            sanitize: true,
        });
        super(props);
    }
    render() {
        const html = marked(html_escape(this.props.markdown));

        return (
            <div className="" dangerouslySetInnerHTML={{
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
        "'": '&#27;',
        '`': '&#x60;'
      };
      return escape[match];
    });
}
export default connect(mapStateToProps, mapDispatchToProps)(Markdown);