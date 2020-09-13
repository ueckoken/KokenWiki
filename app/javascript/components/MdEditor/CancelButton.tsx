import React, { FC } from "react"
import { XIcon } from "@primer/octicons-react"

type Props = {
    onClick: (e: React.MouseEvent<HTMLElement>) => void
}

const CancelButton: FC<Props> = ({ onClick }) => (
    <button
        type="button"
        className="btn btn-secoudary btn-icon"
        onClick={onClick}
    >
        <XIcon />
    </button>
)

export default CancelButton
