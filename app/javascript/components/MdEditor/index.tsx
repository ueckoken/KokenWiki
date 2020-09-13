import React, { FC, useEffect } from "react"
import { Provider } from "react-redux"
import { store, actions, State } from "../redux"
import MdEditor from "./MdEditor"

type Props = Pick<
    State,
    | "title"
    | "markdown"
    | "usergroups"
    | "is_editable"
    | "is_destroyable"
    | "readable_group_id"
    | "editable_group_id"
    | "parent_page_id"
    | "next_parent_pages"
>
const MdEditorApp: FC<Props> = ({
    title,
    markdown,
    usergroups,
    is_editable,
    is_destroyable,
    readable_group_id,
    editable_group_id,
    parent_page_id,
    next_parent_pages,
}) => {
    useEffect(() => {
        store.dispatch(
            actions.setContent({
                title,
                markdown,
                usergroups,
                is_editable,
                is_destroyable,
                readable_group_id,
                editable_group_id,
                parent_page_id,
                next_parent_pages,
            })
        )
    }, [
        title,
        markdown,
        usergroups,
        is_editable,
        is_destroyable,
        readable_group_id,
        editable_group_id,
        parent_page_id,
        next_parent_pages,
    ])
    return (
        <Provider store={store}>
            <MdEditor />
        </Provider>
    )
}

export default MdEditorApp
