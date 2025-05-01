import React, { ComponentType } from "react"
import { createRoot } from "react-dom/client"

async function mountReactComponent(entrypointElement: HTMLElement) {
    const componentName = entrypointElement.dataset.componentName
    if (componentName === undefined) {
        return
    }
    // 1. webpack generates chunk files
    // 2. asset pipeline generates digests for chunk files
    // 3. application.js tries to import non-digest chunk files at runtime and fails to do it
    // workaround: do not generate chunk files
    // see https://webpack.js.org/api/module-methods/ for webpack magic comments
    const Component: ComponentType = (
        await import(
            /* webpackMode: "eager" */
            `./components/${componentName}`
        )
    ).default
    const rawProps = entrypointElement.dataset.props
    const params = rawProps === undefined ? {} : JSON.parse(rawProps)
    const root = createRoot(entrypointElement)
    root.render(<Component {...params} />)
    return root
}

function integrateReactComponent(entrypointElement: HTMLElement) {
    const rootRef = { current: null as any }
    mountReactComponent(entrypointElement).then(root => {
        rootRef.current = root
    })
    document.addEventListener("turbolinks:before-render", () => {
        if (rootRef.current) {
            rootRef.current.unmount()
        }
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
