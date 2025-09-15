import { JSX } from "react";

interface Props {
  containerClasses?: string;
  headingClasses?: string;
  headingData: string | number | JSX.Element;
  id?: string;
  subHeadingClasses?: string;
  subHeadingData: string | number | JSX.Element;
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
    <section id={id} className={containerClasses}>
      <h3 className={headingClasses || "text-xl text-neutral-500"}>
        {headingData}
      </h3>

      <p className={subHeadingClasses || "text-xl"}>{subHeadingData}</p>
    </section>
  );
};

export default GroupDetailsData;
