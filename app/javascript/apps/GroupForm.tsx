import { Field, FieldArray, Form, Formik } from "formik";
import { MdOutlineDeleteForever } from "react-icons/md";
import { RiDeleteBin6Line } from "react-icons/ri";

import GroupsRepository from "../repositories/GroupsRepository";

import { Group, User } from "../types/BaseInterfaces";
import GroupFormUserSelect from "./GroupFormUserSelect";
import { useState } from "react";
import ArchiveGroupModal from "./ArchiveGroupModal";
import { ExpenseStatus } from "../enums/ExpenseStatus";

type InitialGroup = Omit<Group, "expenses"> & {
  id: number | undefined;
  name: string | undefined;
  users: User[] | undefined;
};
export interface InitialGroupFormValues {
  name: string | undefined;
  userIds: number[] | undefined;
  newContacts: string[];
}
interface Props {
  addableUsers: User[];
  currentUser: User;
  group: InitialGroup | Group;
}

const GroupForm = ({ addableUsers, currentUser, group }: Props) => {
  const [showArchiveModal, setShowArchiveModal] = useState(false);

  const isExistingGroup = !!group.id;

  const hasOpenExpenses = () => {
    if ("expenses" in group) {
      return group.expenses.some(
        (expense) => expense.status === ExpenseStatus.Open
      );
    }

    return false;
  };

  const initialUserIds = () => {
    if (group.users.length > 0) {
      return group.users.map((user) => user.id);
    }

    return [currentUser.id];
  };

  const initialValues: InitialGroupFormValues = {
    name: group.name || "",
    userIds: initialUserIds(),
    newContacts: [],
  };

  const userOptions = () => {
    return addableUsers.map((user) => {
      return { label: `${user.firstName} ${user.lastName}`, value: user.id };
    });
  };

  const handleSubmit = async (values: InitialGroupFormValues) => {
    const response = isExistingGroup
      ? await GroupsRepository.update({ ...values, groupId: group.id })
      : await GroupsRepository.create(values);

    if (response) {
      window.location.href = `/groups/${response.group.id}`;
    }
  };

  const renderButtons = () => {
    if (isExistingGroup) {
      return (
        <div className="flex items-center justify-between">
          <a
            className="h-full rounded-md px-6 py-2 border border-indigo-400 hover:bg-neutral-100 focus:bg-neutral-300 text-indigo-500 text-center"
            href={`/groups/${group.id}`}
          >
            Cancel
          </a>

          <button
            type="submit"
            className="bg-indigo-500 hover:bg-indigo-600 focus:outline-indigo-900 rounded-md text-white px-2 py-2 cursor:pointer"
          >
            Update group
          </button>
        </div>
      );
    }

    return (
      <button
        type="submit"
        className="w-full bg-indigo-500 hover:bg-indigo-600 focus:outline-indigo-900 rounded-md text-white py-2 mb-6 cursor:pointer"
      >
        Create Group
      </button>
    );
  };

  return (
    <>
      <div className="flex flex-col items-center justify-center py-20">
        <div className="flex flex-col bg-white shadow rounded-lg p-8 max-w-md">
          <Formik initialValues={initialValues} onSubmit={handleSubmit}>
            {({ values }) => (
              <Form>
                <div className="mb-6">
                  <label htmlFor="name" className="text-gray-500">
                    Group name
                  </label>

                  <Field
                    type="text"
                    name="name"
                    id="name"
                    className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full"
                  />
                </div>

                {userOptions().length > 0 && (
                  <div className="mb-6">
                    <label htmlFor="userIds" className="text-gray-500">
                      Group Members
                      <div className="text-xs">
                        Add members from your existing groups
                      </div>
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

                <hr className="mb-2" />

                <FieldArray name="newContacts">
                  {({ insert, remove, push }) => (
                    <div>
                      {values.newContacts.length > 0 && (
                        <div>
                          <p className="text-sm text-neutral-600 mb-2">
                            An email will be sent to the address(es) provided
                            below inviting the recipient to join this group. If
                            the recipient does not already have an account, they
                            will also be invited to create one.
                          </p>

                          {values.newContacts.map((_newContact, index) => (
                            <div
                              className="flex items-center justify-between gap-2 w-full mb-4"
                              key={index}
                            >
                              <Field
                                className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 w-full px-3 py-2"
                                name={`newContacts.${index}`}
                                type="email"
                              />

                              <button
                                aria-label={`Remove New Contact ${index}`}
                                onClick={() => remove(index)}
                              >
                                <RiDeleteBin6Line size={25} />
                              </button>
                            </div>
                          ))}
                        </div>
                      )}

                      <button
                        className="text-indigo-400 hover:text-indigo-500 mb-6"
                        type="button"
                        onClick={() => push("")}
                      >
                        Invite new contact
                      </button>
                    </div>
                  )}
                </FieldArray>

                {renderButtons()}
              </Form>
            )}
          </Formik>
        </div>

        {isExistingGroup && (
          <button
            className="mt-6 rounded-md px-3 py-2 bg-rose-400 hover:bg-rose-500 focus:bg-rose-500 text-white text-2xl text-center"
            id="archive-group"
            onClick={() => setShowArchiveModal(true)}
          >
            {`Archive ${group.name}`}
          </button>
        )}
      </div>

      {showArchiveModal && (
        <ArchiveGroupModal
          group={group as Group}
          hasOpenExpenses={hasOpenExpenses()}
          isOpen={showArchiveModal}
          onClose={() => setShowArchiveModal(false)}
        />
      )}
    </>
  );
};

export default GroupForm;
