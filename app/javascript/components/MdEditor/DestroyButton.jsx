import React from "react"
import { TrashcanIcon } from "@primer/octicons-react"

const DestroyButton = () => (
    <button
        type="submit"
        className="btn btn-danger btn-icon"
        form="page-destroy-form"
    >
        <TrashcanIcon />
    </button>
)

export default DestroyButton
