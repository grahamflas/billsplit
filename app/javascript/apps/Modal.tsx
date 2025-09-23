import { PropsWithChildren, useEffect, useRef } from "react";

import { IoMdClose } from "react-icons/io";

interface Props {
  id?: string;
  isOpen: boolean;
  onCloseModal: () => void;
  title: string;
}

const Modal = ({
  id,
  children,
  isOpen,
  onCloseModal,
  title,
}: PropsWithChildren<Props>) => {
  const dialogRef = useRef<HTMLDialogElement>(null);

  const handleEscapeKeyPress = (event: KeyboardEvent) => {
    console.log("key pressed");
    if (event.key === "Escape") {
      console.log("...it was escape");
      event.preventDefault();

      closeModal();
    }
  };

  useEffect(() => {
    const dialog = dialogRef.current;

    if (dialog) {
      const openModal = () => {
        if (!dialog.open) {
          dialog.showModal();
        }
      };

      if (isOpen) {
        openModal();

        document.addEventListener("keydown", handleEscapeKeyPress);
      } else if (dialog.open) {
        closeModal();
      }
    }

    return () => document.removeEventListener("keydown", handleEscapeKeyPress);
  }, [isOpen]);

  const closeModal = () => {
    const dialog = dialogRef.current;

    if (dialog) {
      dialog.close();

      onCloseModal();
    }
  };

  return (
    <dialog
      className="rounded-2xl max-h-screen w-full max-w-2xl mx-auto md:max-w-none md:w-fit overflow-y-auto"
      id="dialog"
      ref={dialogRef}
    >
      <div id={id} className="flex flex-col">
        <header className="flex items-center justify-start gap-6 px-6 py-4 border border-cream border-b border-t-0 border-x-0">
          <button onClick={onCloseModal}>
            <IoMdClose size={18} />
          </button>

          <h2 className="text-2xl text-center flex-grow">{title}</h2>
        </header>

        <div className="px-6 py-8 overflow-auto">{children}</div>
      </div>
    </dialog>
  );
};

export default Modal;
