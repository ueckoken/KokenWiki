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
        const html = marked(escape(this.props.markdown));

        return (
            <div className="" dangerouslySetInnerHTML={{
                __html: html
            }}>
            </div>);
    }
};

export default connect(mapStateToProps, mapDispatchToProps)(Markdown);