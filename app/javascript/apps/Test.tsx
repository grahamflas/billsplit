import ChildComponent from "./ChildComponent";

interface Props {
  userName: string;
  location: string;
}
const Test = ({ userName, location }: Props) => {
  return (
    <div>
      {`Hi ${userName}, you're in ${location}.`}

      <ChildComponent />
    </div>
  );
};

export default Test;
