import React, { Fragment } from "react"
import { Tab, Tabs, TabList, TabPanel } from "react-tabs"
import { useSelector, useDispatch } from "react-redux"
import Markdown from "./Markdown"
import Editor from "./Editor"
import { actions, selectors } from "./redux"

const MdEditor = () => {
    const usergroups = useSelector((state) => state.usergroups)
    const readable_group_id = useSelector((state) => state.readable_group_id)
    const editable_group_id = useSelector((state) => state.editable_group_id)
    const is_draft = useSelector((state) => state.is_draft)
    const is_editable = useSelector((state) => state.is_editable)
    const is_changed = useSelector(selectors.isChanged)
    const is_edit = useSelector((state) => state.is_edit)

    const dispatch = useDispatch()
    const handleOnClickEdit = () => dispatch(actions.onClickEdit())
    const handleOnClickCancel = () => dispatch(actions.onClickCancel())
    const handleOnClickIsDraft = () => dispatch(actions.onClickIsDraft())
    const handleChangeReadableGroup = (e) =>
        dispatch(actions.changeReadableGroup(Number(e.target.value)))
    const handleChangeEditableGroup = (e) =>
        dispatch(actions.changeEditableGroup(Number(e.target.value)))

    if (!is_edit) {
        return (
            <Fragment>
                <button
                    type="button"
                    hidden={!is_editable}
                    className="btn btn-secondary"
                    onClick={handleOnClickEdit}
                >
                    編集
                </button>
                <Markdown highlight={!is_edit}></Markdown>
            </Fragment>
        )
    }
    return (
        <div>
            <div className="btn-toolbar justify-content-between">
                <div className="btn-group">
                    <button
                        type="button"
                        className="btn btn-secondary"
                        onClick={handleOnClickCancel}
                    >
                        破棄
                    </button>
                </div>
                <div className="btn-group">
                    <input
                        type="submit"
                        value="保存"
                        className="btn btn-primary"
                        hidden={!is_changed}
                    />
                </div>
            </div>
            <div className="d-xl-none">
                <MdEditorSm />
            </div>
            <div className="d-none d-xl-flex width100">
                <MdEditorLg />
            </div>
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
            <div className="form-check">
                <input
                    type="checkbox"
                    className="form-check-input"
                    checked={is_draft}
                    onChange={handleOnClickIsDraft}
                />
                <label className="form-check-label">下書き</label>
                <input type="hidden" name="page[is_draft]" value={is_draft} />
            </div>
        </div>
    )
}

const MdEditorSm = () => (
    <form>
        <Tabs>
            <TabList>
                <Tab>プレビュー</Tab>
                <Tab>編集</Tab>
            </TabList>

            <TabPanel>
                <Markdown highlight={false} />
            </TabPanel>
            <TabPanel>
                <Editor />
            </TabPanel>
        </Tabs>
    </form>
)

const MdEditorLg = () => (
    <div className="row width100">
        <div className="col-6">
            <Tabs>
                <TabList>
                    <Tab>プレビュー</Tab>
                </TabList>

                <TabPanel>
                    <div
                        style={{
                            maxHeight: 600,
                            overflowY: "auto",
                        }}
                    >
                        <Markdown highlight={false} />
                    </div>
                </TabPanel>
            </Tabs>
        </div>
        <div className="col-6">
            <Tabs>
                <TabList>
                    <Tab>編集</Tab>
                </TabList>
                <TabPanel>
                    <Editor />
                </TabPanel>
            </Tabs>
        </div>
    </div>
)

export default MdEditor
