import { JSX } from "react";

interface Props {
  containerClasses?: string;
  headingClasses?: string;
  headingData: string | JSX.Element;
  id?: string;
  subHeadingClasses?: string;
  subHeadingData: string | number;
}
const GroupDetailsData = ({
  containerClasses,
  headingClasses,
  headingData,
  id,
  subHeadingClasses,
  subHeadingData,
}: Props) => {
  return (
    <div id={id} className={containerClasses}>
      <h3 className={headingClasses || "text-xl text-neutral-500"}>
        {headingData}
      </h3>

      <div className={subHeadingClasses || "text-xl"}>{subHeadingData}</div>
    </div>
  );
};

export default GroupDetailsData;
