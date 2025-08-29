import { Group } from "../types/BaseInterfaces";

interface Props {
  groups: Group[];
}

const GroupsContainer = ({ groups }: Props) => {
  return <div>Hey from GroupsContainer</div>;
};

export default GroupsContainer;
