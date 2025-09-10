import { useEffect } from "react";
import { toast, ToastContainer } from "react-toastify";

interface Props {
  toasts: string[];
}

const Toaster = ({ toasts }: Props) => {
  useEffect(() => {
    toasts.forEach(toast);
  });

  return <ToastContainer />;
};

export default Toaster;
