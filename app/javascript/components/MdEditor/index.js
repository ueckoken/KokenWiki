import React, { useEffect } from "react";
import { Provider } from 'react-redux';
import { configureStore } from "@reduxjs/toolkit";
import MdEditorReducer from "./MdEditorReducer"
import { setContent } from "./Actions"
import MdEditor from "./MdEditor"

const store = configureStore({
    reducer: MdEditorReducer
});

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
            setContent({
                markdown,
                usergroups,
                is_editable: editable,
                readable_group_id,
                editable_group_id,
                is_draft,
                is_public
            })
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