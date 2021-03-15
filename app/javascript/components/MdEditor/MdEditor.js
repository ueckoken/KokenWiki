import React, { Fragment } from "react"
import { useSelector, useDispatch } from "react-redux"
import Markdown from "./Markdown"
import Editor from "./Editor"
import { actions, selectors } from "../redux"
import SaveButton from "./SaveButton"
import CancelButton from "./CancelButton"
import EditButton from "./EditButton"
import DestroyButton from "./DestroyButton"

const Header = () => {
    const title = useSelector((state) => state.title)
    const default_title = useSelector((state) => state.default_title)
    const is_title_editable = default_title !== ""
    const is_editing = useSelector((state) => state.is_editing)
    const is_destroyable = useSelector((state) => state.is_destroyable)
    const is_changed = useSelector(selectors.isChanged)
    const dispatch = useDispatch()
    const handleChangeTitle = (e) =>
        dispatch(actions.changeTitle(e.target.value))
    const handleOnClickEdit = () => dispatch(actions.onClickEdit())
    const handleOnClickCancel = () => dispatch(actions.onClickCancel())

    return (
        <div className="d-flex justify-content-between">
            {is_editing ? (
                <input
                    type="text"
                    name="page[title]"
                    readOnly={!is_title_editable}
                    className="form-control"
                    value={title}
                    onChange={handleChangeTitle}
                />
            ) : (
                <h1>{title}</h1>
            )}
            <div className="d-inline-flex">
                {is_editing && <SaveButton disabled={!is_changed} />}
                {is_editing && <CancelButton onClick={handleOnClickCancel} />}
                {!is_editing && <EditButton onClick={handleOnClickEdit} />}
                {is_destroyable && !is_editing && <DestroyButton />}
            </div>
        </div>
    )
}

const ParentPageSelector = () => {
    const parent_page_id = useSelector((state) => state.parent_page_id)
    const next_parent_pages = useSelector((state) => state.next_parent_pages)
    const dispatch = useDispatch()
    const handleChangeParentPage = (e) =>
        dispatch(actions.changeParentPage(Number(e.target.value)))

    if (next_parent_pages.length === 0) {
        return null
    }

    return (
        <Fragment>
            <label>親ページ</label>
            <select
                value={parent_page_id}
                name="page[parent_page_id]"
                className="form-control"
                onChange={handleChangeParentPage}
            >
                {next_parent_pages.map((page) => (
                    <option value={page.id} key={page.id}>
                        {page.path}
                    </option>
                ))}
            </select>
        </Fragment>
    )
}

const MdEditor = () => {
    const usergroups = useSelector((state) => state.usergroups)
    const readable_group_id = useSelector((state) => state.readable_group_id)
    const editable_group_id = useSelector((state) => state.editable_group_id)
    const is_editing = useSelector((state) => state.is_editing)

    const dispatch = useDispatch()
    const handleChangeReadableGroup = (e) =>
        dispatch(actions.changeReadableGroup(Number(e.target.value)))
    const handleChangeEditableGroup = (e) =>
        dispatch(actions.changeEditableGroup(Number(e.target.value)))

    if (!is_editing) {
        return (
            <Fragment>
                <Header />
                <Markdown />
            </Fragment>
        )
    }
    return (
        <div>
            <Header />
            <div>
                <ParentPageSelector />
            </div>
            <Editor />
            <div>
                <label>閲覧可能グループ</label>
                <select
                    value={readable_group_id}
                    name="page[readable_group_id]"
                    className="form-control"
                    onChange={handleChangeReadableGroup}
                >
                    <option key={0} value={0}>
                        部員全員
                    </option>
                    {usergroups.map((usergroup, i) => (
                        <option value={usergroup.id} key={i + 1}>
                            {usergroup.name}
                        </option>
                    ))}
                </select>
            </div>
            <div>
                <label>編集可能グループ</label>
                <select
                    value={editable_group_id}
                    name="page[editable_group_id]"
                    className="form-control"
                    onChange={handleChangeEditableGroup}
                >
                    <option value={0}>部員全員</option>
                    {usergroups.map((usergroup, i) => (
                        <option value={usergroup.id} key={i + 1}>
                            {usergroup.name}
                        </option>
                    ))}
                </select>
            </div>
        </div>
    )
}

export default MdEditor
