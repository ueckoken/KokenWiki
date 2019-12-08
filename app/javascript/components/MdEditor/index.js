import React, { useEffect } from "react";
import { createStore } from "redux";
import { Provider } from 'react-redux';
import MdEditorReducer from "./MdEditorReducer"
import { setContent } from "./Actions"
import MdEditor from "./MdEditor"

const store = createStore(MdEditorReducer);

export default ({
    markdown,
    usergroups,
    editable,
    readable_group_id,
    editable_group_id,
    is_draft,
    is_public
}) => {
    useEffect(() => {
        store.dispatch(
            setContent(
                markdown,
                usergroups,
                editable,
                readable_group_id,
                editable_group_id,
                is_draft,
                is_public
            )
        );
    }, [
        markdown,
        usergroups,
        editable,
        readable_group_id,
        editable_group_id,
        is_draft,
        is_public
    ]);
    return (
        <Provider store={store}>
            <MdEditor />
        </Provider>
    );
};