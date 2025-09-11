import { JSX } from "react";

interface Props {
  children: JSX.Element;
  id?: string;
}

const GroupDetailsSection = ({ children, id = undefined }: Props) => {
  return (
    <div
      id={id}
      className="flex flex-col rounded-2xl bg-white px-10 py-6 gap-6"
    >
      {children}
    </div>
  );
};

export default GroupDetailsSection;
