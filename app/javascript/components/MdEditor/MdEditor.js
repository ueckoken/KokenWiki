import React from 'react'
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import { connect, useSelector } from 'react-redux';
import Markdown from "./Markdown";
import Editor from "./Editor";
import {
    onClickEdit,
    onClickCancel,
    onClickIsDraft,
    onClickIsPublic,
    changeReadableGroup,
    changeEditableGroup,
} from "./Actions";
import { isChangedSelector } from "./selectors";

const MdEditor = ({
    usergroups,
    is_edit,
    is_editable,
    readable_group_id,
    editable_group_id,
    is_draft,
    is_public,
    handleOnClickEdit,
    handleOnClickCancel,
    handleOnClickIsDraft,
    handleOnClickIsPublic,
    handleChangeReadableGroup,
    handleChangeEditableGroup,
  }) => {
    const is_changed = useSelector(isChangedSelector);
    if (!is_edit) {
        return (
            <div>
                <button type="button" hidden={!is_editable} className="btn btn-secondary" onClick={() => handleOnClickEdit()}>編集</button>
                <Markdown highlight={!is_edit}></Markdown>
            </div>
        );
    }
    return (
        <div>
            <div className="d-xl-none">
                <MdEditorSm />
            </div>
            <div className="d-none d-xl-flex width100">
                <MdEditorLg />
            </div>
            <div>
                <label>閲覧可能グループ</label>
                <select value={readable_group_id} name="page[readable_group_id]" className="form-control" onChange={e => handleChangeReadableGroup(Number(e.target.value))}>
                    <option key={0} value={0}>部員全員</option>
                    {usergroups.map((usergroup, i) => <option value={usergroup.id} key={i + 1}>{usergroup.name}</option>)}
                </select>
            </div>
            <div>
                <label>編集可能グループ</label>
                <select value={editable_group_id} name="page[editable_group_id]" className="form-control" onChange={e => handleChangeEditableGroup(Number(e.target.value))}>

                    <option value={0}>部員全員</option>
                    {usergroups.map((usergroup, i) => <option value={usergroup.id} key={i + 1}>{usergroup.name}</option>)}
                </select>
            </div>
            <div className="form-check">
                <input type="checkbox" className="form-check-input" checked={is_draft} onChange={() => handleOnClickIsDraft()} />
                <label className="form-check-label">下書き</label>
                <input type="hidden" name="page[is_draft]" value={is_draft} />
            </div>
            <div className="form-check">
                <input type="checkbox" className="form-check-input" checked={is_public} onChange={() => handleOnClickIsPublic()} />
                <label className="form-check-label">一般公開</label>
                <input type="hidden" name="page[is_public]" value={is_public} />
            </div>
            <button type="button" className="btn btn-secondary" onClick={() => handleOnClickCancel()}>破棄</button>
            <input type="submit" value="保存" className="btn btn-primary" style={{ float: "right" }} hidden={!is_changed}></input>
        </div>
    );
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
);

const MdEditorLg = () => (
    <div className="row width100">
        <div className="col-6">
            <Tabs>
                <TabList>
                    <Tab>プレビュー</Tab>
                </TabList>

                <TabPanel>
                    <Markdown highlight={false} />
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
);

export default connect((state) => ({
    usergroups: state.usergroups,
    is_edit: state.is_edit,
    is_editable: state.is_editable,
    readable_group_id: state.readable_group_id,
    editable_group_id: state.editable_group_id,
    is_draft: state.is_draft,
    is_public: state.is_public,
}), {
    handleOnClickEdit: onClickEdit,
    handleOnClickCancel: onClickCancel,
    handleOnClickIsDraft: onClickIsDraft,
    handleOnClickIsPublic: onClickIsPublic,
    handleChangeReadableGroup: changeReadableGroup,
    handleChangeEditableGroup: changeEditableGroup,
})(MdEditor);