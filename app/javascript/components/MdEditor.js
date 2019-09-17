import marked from 'marked';
import PropTypes from 'prop-types'
import React from 'react'
import ReactDOM from 'react-dom'
import * as escape from 'escape-html';
import { Tab, Tabs, TabList, TabPanel } from 'react-tabs';
import { hidden } from 'ansi-colors';
class MdEditor extends React.Component {
    
    constructor(props) {
        super(props);
        this.state = {
            markdown: "",
            tabIndex: 0
        };
    }

    handleSelect(index, last) {
        //console.log('Selected tab: ' + index + ', Last tab: ' + last);
        this.setState({ tabIndex: index });
    }
    render() {
        return (
            <React.Fragment>
                <div className="d-lg-none">
                    <MdEditorSm
                        tabSelected={this.handleSelect.bind(this)}
                        markdown={this.state.markdown}
                        tabIndex={this.state.tabIndex}
                        onChangeText={this.onChangeText.bind(this)}>
                        
                    </MdEditorSm>
                </div>
                <div className="d-none d-lg-flex width100">
                    <MdEditorLg
                        tabSelected={this.handleSelect.bind(this)}
                        markdown={this.state.markdown}
                        tabIndex={this.state.tabIndex}
                        onChangeText={this.onChangeText.bind(this)}>

                    </MdEditorLg>
                </div>
            </React.Fragment>
        );
    }
    onChangeText(e) {
        this.setState({
            markdown: e.target.value
        });
    }
}
class MdEditorSm extends React.Component{

    constructor(props) {
        super(props);
    }
    render() {
        return (
            <Tabs
                onSelect={this.props.tabSelected}
                selectedIndex={this.props.tabIndex}
            >

                <TabList>
                    <Tab>プレビュー</Tab>
                    <Tab>編集</Tab>
                </TabList>

                <TabPanel>
                    <Markdown md={this.props.markdown}></Markdown>
                </TabPanel>
                <TabPanel>
                    <Editor text={this.props.markdown} onChange={this.props.onChangeText}>
                    </Editor>
                </TabPanel>

            </Tabs>
        );
    }
    onChangeText(e) {
        this.setState({
            markdown: e.target.value
        });
    }
}
class MdEditorLg extends React.Component{

    constructor(props) {
        super(props);
    }
    render() {
        return (
            <div className="row width100">
                <div className="col-6">
                    <Tabs>
                        <TabList>
                            <Tab>プレビュー</Tab>
                        </TabList>

                        <TabPanel>
                            <Markdown md={this.props.markdown}></Markdown>
                        </TabPanel>
                    </Tabs>
                </div>
                <div className="col-6">

                    <Tabs>
                        <TabList>
                            <Tab>編集</Tab>
                        </TabList>
                        <TabPanel>
                            <Editor text={this.props.markdown} onChange={this.props.onChangeText}>
                            </Editor>
                        </TabPanel>

                    </Tabs>
                </div>
            </div>
        );
    }
}
class Editor extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        return <div>
            <textarea
                className="form-control"
                value={this.props.text}
                onChange={this.props.onChange}>

            </textarea>
        </div>
    }
}
class Markdown extends React.Component {
    constructor(props) {
        super(props);
    }
    render() {
        const html = marked(escape(this.props.md));

        return (
            <div className="" dangerouslySetInnerHTML={{
                __html: html
            }}>
        </div>);
    }
}

export default MdEditor;