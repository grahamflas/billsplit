import { Field, Form, Formik } from "formik";

import ExpensesRepository from "../repositories/ExpensesRepository";

import { Expense, Group } from "../types/BaseInterfaces";

interface EditExpenseFormValues
  extends Pick<Expense, "reference" | "amount" | "userId"> {}

interface Props {
  expense: Expense;
  group: Group;
  onCancel: () => void;
}

const ExpenseEditForm = ({ expense, group, onCancel }: Props) => {
  const handleSubmit = async (values: EditExpenseFormValues) => {
    const expenseUpdated = await ExpensesRepository.update({
      ...values,
      id: expense.id,
    });

    if (expenseUpdated) {
      window.location.href = `/groups/${group.id}`;
    }
  };

  const initialValues: EditExpenseFormValues = {
    reference: expense.reference,
    amount: expense.amount,
    userId: expense.userId,
  };

  return (
    <Formik initialValues={initialValues} onSubmit={handleSubmit}>
      <Form>
        <label htmlFor="reference" className="text-gray-500">
          Reference
        </label>

        <Field
          className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
          id="reference"
          name="reference"
          type="text"
        />

        <label htmlFor="amount" className="text-gray-500">
          Amount
        </label>

        <Field
          className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
          id="amount"
          name="amount"
          type="number"
        />

        <label className="text-gray-500" htmlFor="userId">
          Paid by
        </label>

        <Field
          className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
          as="select"
          name="userId"
          id="userId"
        >
          {group.users.map((user) => (
            <option value={user.id} key={user.id}>
              {`${user.firstName} ${user.lastName}`}
            </option>
          ))}
        </Field>

        <div className="flex justify-between">
          <button
            className="rounded-md px-3 py-1 border border-indigo-400 hover:bg-neutral-100 focus:bg-neutral-300 text-indigo-500 text-center"
            type="button"
            onClick={onCancel}
          >
            cancel
          </button>

          <button
            className="rounded-md px-3 py-1 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-center"
            type="submit"
          >
            submit
          </button>
        </div>
      </Form>
    </Formik>
  );
};

export default ExpenseEditForm;
