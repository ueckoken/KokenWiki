import React from 'react';
import { connect } from 'react-redux';
import TextareaAutosize from 'react-autosize-textarea';
import { changeText } from "./Actions"

export const Editor = ({ markdown, handleChangeText }) => (
    <div>
        <TextareaAutosize
            className="form-control"
            row={5}
            value={markdown}
            onChange={e => handleChangeText(e.target.value)}
            name="page[content]"
        />
    </div>
);

export default connect(state => ({
    markdown: state.markdown
}), {
    handleChangeText: changeText
})(Editor);