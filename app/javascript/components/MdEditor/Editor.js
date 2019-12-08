import React from 'react';
import { connect } from 'react-redux';
import { end } from 'worker-farm';
import TextareaAutosize from 'react-autosize-textarea';
import Actions from "./Actions"
export class Editor extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        return <div>
            <TextareaAutosize
                className="form-control"
                row={5}
                value={this.props.markdown}
                onChange={this.props.handleChangeText}
                name="page[content]"
                />
        </div>
    }
}


export default connect(state => ({
    markdown: state.markdown
}), {
    handleChangeText: Actions.changeText
})(Editor);