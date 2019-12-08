import React from 'react';
import { connect } from 'react-redux';
import { end } from 'worker-farm';
import TextareaAutosize from 'react-autosize-textarea';
import { changeText } from "./Actions"

export const Editor = ({ markdown, handleChangeText }) => (
    <div>
        <TextareaAutosize
            className="form-control"
            row={5}
            value={markdown}
            onChange={handleChangeText}
            name="page[content]"
        />
    </div>
);

export default connect(state => ({
    markdown: state.markdown
}), {
    handleChangeText: changeText
})(Editor);