import React, { FC } from "react"
import { TrashIcon } from "@primer/octicons-react"

const DestroyButton: FC = () => (
    <button
        type="submit"
        className="btn btn-danger btn-icon"
        form="page-destroy-form"
    >
        <TrashIcon />
    </button>
)

export default DestroyButton
