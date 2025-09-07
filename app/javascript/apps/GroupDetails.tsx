import { format, max } from "date-fns";

import BalancesData from "./BalancesData";
import Expense from "./Expense";
import GroupDetailsData from "./GroupDetailsData";
import GroupDetailsSection from "./GroupDetailsSection";
import GroupedAvatars from "./GroupedAvatars";

import { Balances, Group, User } from "../types/BaseInterfaces";
import Modal from "./Modal";
import { useState } from "react";
import { Field, Form, Formik } from "formik";

interface Props {
  balances: Balances;
  currentUser: User;
  group: Group;
}

const GroupDetails = ({ balances, currentUser, group }: Props) => {
  const [showNewExpenseModal, setShowNewExpenseModal] =
    useState<boolean>(false);

  const groupMembersList = () => {
    return group.users.map((user) => user.firstName).join(", ");
  };

  const latestDate = () => {
    if (group.expenses.length > 0) {
      const dates = group.expenses.map(
        (expense) => new Date(expense.createdAt)
      );

      return format(max(dates), "MMM d, yyyy");
    }

    return "-";
  };

  const handleSumbit = (values) => {
    console.log(values);
  };

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <div className="flex flex-col gap-6">
        <GroupDetailsSection>
          <>
            <div className="flex flex-row justify-between">
              <div className="flex flex-col gap-1">
                <h2 className="text-4xl">{group.name}</h2>

                <span className="text-neutral-500">{groupMembersList()}</span>
              </div>

              <div className="flex flex-row -space-x-2">
                <GroupedAvatars users={group.users} />
              </div>
            </div>

            <div className="rounded-2xl bg-neutral-100 p-6 mx-4">
              <GroupDetailsData
                headingData="Total Expenses"
                subHeadingData={Intl.NumberFormat("en-US", {
                  style: "currency",
                  currency: "USD",
                }).format(balances.totalExpenses)}
                subHeadingClasses="text-3xl mt-2"
              />

              <div className="mt-8">
                <BalancesData balances={balances} currentUser={currentUser} />
              </div>
            </div>

            <div className="flex flex-row justify-between">
              <div>
                <GroupDetailsData
                  headingData="Members"
                  subHeadingData={group.users.length}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Expenses"
                  subHeadingData={group.expenses.length || "-"}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Latest Activity"
                  subHeadingData={latestDate()}
                />
              </div>
            </div>
          </>
        </GroupDetailsSection>

        <button
          className="rounded-md px-3 py-2 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-2xl text-center"
          onClick={() => setShowNewExpenseModal(true)}
        >
          + Add Expense
        </button>

        {group.expenses.length > 0 && (
          <GroupDetailsSection>
            <>
              {group.expenses.map((expense, i) => (
                <Expense
                  expense={expense}
                  isInitialExpense={i === 0}
                  key={expense.id}
                />
              ))}
            </>
          </GroupDetailsSection>
        )}
      </div>

      <Modal
        isOpen={showNewExpenseModal}
        onCloseModal={() => setShowNewExpenseModal(false)}
        title={`New Expense for ${group.name}`}
      >
        <Formik
          initialValues={{ reference: "", amount: "", userId: "" }}
          onSubmit={handleSumbit}
        >
          <Form className="flex flex-col">
            <label htmlFor="reference" className="text-gray-500">
              Reference
            </label>

            <Field
              className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
              name="reference"
              type="text"
            />

            <label htmlFor="amount" className="text-gray-500">
              Amount
            </label>

            <Field
              className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
              name="amount"
              type="number"
            />

            <label htmlFor="userId" className="text-gray-500">
              Paid by
            </label>

            <Field
              className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
              name="userId"
              as="select"
            >
              {group.users.map((user) => (
                <option
                  value={user.id}
                >{`${user.firstName} ${user.lastName}`}</option>
              ))}
            </Field>

            <button
              type="submit"
              className="w-full bg-indigo-500 hover:bg-indigo-600 focus:outline-indigo-900 rounded-md text-white py-2 mb-6 cursor:pointer"
            >
              Submit
            </button>
          </Form>
        </Formik>
      </Modal>
    </div>
  );
};

export default GroupDetails;
