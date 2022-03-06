import React, { ComponentType } from "react"
import ReactDOM from "react-dom"

async function mountReactComponent(entrypointElement: HTMLElement) {
    const componentName = entrypointElement.dataset.componentName
    if (componentName === undefined) {
        return
    }
    const Component: ComponentType = (
        await import(`./components/${componentName}`)
    ).default
    const rawProps = entrypointElement.dataset.props
    const params = rawProps === undefined ? {} : JSON.parse(rawProps)
    ReactDOM.render(<Component {...params} />, entrypointElement)
}

function integrateReactComponent(entrypointElement: HTMLElement) {
    mountReactComponent(entrypointElement)
    document.addEventListener("turbolinks:before-render", () => {
        ReactDOM.unmountComponentAtNode(entrypointElement)
    })
}

export function start() {
    document.addEventListener("turbolinks:load", () => {
        const entrypointElements = document.querySelectorAll<HTMLElement>(
            "[class^=react-component]"
        )
        for (const entrypointElement of Array.from(entrypointElements)) {
            integrateReactComponent(entrypointElement)
        }
    })
}
