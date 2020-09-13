import React, { FC } from "react"
import { TrashcanIcon } from "@primer/octicons-react"

const DestroyButton: FC = () => (
    <button
        type="submit"
        className="btn btn-danger btn-icon"
        form="page-destroy-form"
    >
        <TrashcanIcon />
    </button>
)

export default DestroyButton
