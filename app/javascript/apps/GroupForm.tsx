import { Field, Form, Formik } from "formik";

import GroupsRepository from "../repositories/GroupsRepository";

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

  const handleSubmit = async (values: InitialGroupFormValues) => {
    const response = await GroupsRepository.create(values);

    if (response) {
      window.location.href = `/groups/${response.group.id}`;
    }
  };

  return (
    <div className="flex items-center justify-center py-20">
      <div className="flex flex-col bg-white shadow rounded-lg p-8 max-w-md">
        <Formik initialValues={initialValues} onSubmit={handleSubmit}>
          <Form>
            <div className="mb-6">
              <Field
                type="text"
                name="name"
                id="name"
                className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full"
              />
              <label htmlFor="name" className="text-gray-500">
                Group name
              </label>
            </div>

            {userOptions().length > 0 && (
              <div className="mb-6">
                <label htmlFor="userIds" className="text-gray-500">
                  Group Members
                </label>
                <Field
                  name="userIds"
                  id="userIds"
                  component={GroupFormUserSelect}
                  options={userOptions()}
                  isMulti
                  className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full"
                />
              </div>
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
    </div>
  );
};

export default GroupForm;
