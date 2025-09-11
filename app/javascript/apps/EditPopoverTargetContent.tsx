import { useEffect, useRef } from "react";
import {
  Popover,
  Target,
  Trigger,
  useControls,
  usePopover,
} from "@accessible/popover";
import { Expense } from "../types/BaseInterfaces";

interface Props {
  expense: Expense;
  onEdit: () => void;
}

const EditPopoverTargetContent = ({ expense, onEdit }: Props) => {
  const popover = usePopover();

  const popoverRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    console.log("registering click listener");
    window.addEventListener("click", handleBackgroundClick);

    return () => {
      console.log("UNregistering click listener");
      window.removeEventListener("click", handleBackgroundClick);
    };
  }, []);

  const handleBackgroundClick = (event: MouseEvent) => {
    const { clientX, clientY } = event;

    if (popoverRef.current) {
      const rect = popoverRef.current.getBoundingClientRect();

      const rectClicked =
        clientX >= rect.left &&
        clientX <= rect.right &&
        clientY >= rect.top &&
        clientY <= rect.bottom;

      if (!rectClicked) {
        popover.close();
      }
    }
  };

  return (
    <Target placement="bottomLeft">
      <div ref={popoverRef} className="bg-white shadow-lg rounded-2xl p-2">
        <ul className="flex flex-col gap-2 items-center">
          <li className="w-full">
            <button
              id={`edit-expense-${expense.id}-button`}
              className="hover:bg-neutral-200 px-6 py-1 rounded w-full"
              onClick={() => {
                popover.close();
                onEdit();
              }}
            >
              Edit
            </button>
          </li>

          <li className="w-full">
            <button className="hover:bg-rose-200 focus:bg-rose-200 px-6 py-1 rounded w-full">
              Delete
            </button>
          </li>
        </ul>
      </div>
    </Target>
  );
};

export default EditPopoverTargetContent;
