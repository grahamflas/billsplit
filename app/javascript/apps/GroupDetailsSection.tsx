import { JSX } from "react";

interface Props {
  children: JSX.Element;
}

const GroupDetailsSection = ({ children }: Props) => {
  return (
    <div className="flex flex-col rounded-2xl bg-white px-10 py-6 gap-6">
      {children}
    </div>
  );
};

export default GroupDetailsSection;
