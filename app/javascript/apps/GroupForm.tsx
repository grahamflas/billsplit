import Select from "react-select";
import { Field, Form, Formik } from "formik";
import { Group, User } from "../types/BaseInterfaces";
import GroupFormUserSelect from "./GroupFormUserSelect";

type InitialGroup = Omit<Group, "expenses"> & {
  id: number | undefined;
  name: string | undefined;
  users: User[] | undefined;
};
export interface InitialGroupFormValues {
  name: string | undefined;
  userIds: number[] | undefined;
}
interface Props {
  addableUsers: User[];
  group: InitialGroup;
}

const GroupForm = ({ addableUsers, group }: Props) => {
  const initialValues: InitialGroupFormValues = {
    name: group.name || "",
    userIds: group.users?.map((user) => user.id) || [],
  };

  const userOptions = () => {
    return addableUsers.map((user) => {
      return { label: `${user.firstName} ${user.lastName}`, value: user.id };
    });
  };

  return (
    <div>
      <Formik
        initialValues={initialValues}
        onSubmit={(values) => console.log(values)}
      >
        <Form>
          <label htmlFor="name">Group Name</label>
          <Field type="text" name="name" id="name" />

          {userOptions() && (
            <>
              <label htmlFor="userIds">Group Members</label>
              <Field
                name="userIds"
                id="userIds"
                component={GroupFormUserSelect}
                options={userOptions()}
                isMulti
              />
            </>
          )}

          <button
            type="submit"
            className="w-full bg-indigo-500 hover:bg-indigo-600 focus:outline-indigo-900 rounded-md text-white py-2 mb-6 cursor:pointer"
          >
            Create Group
          </button>
        </Form>
      </Formik>
    </div>
  );
};

export default GroupForm;
