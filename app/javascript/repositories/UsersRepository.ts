import ajax from "../utils/ajax";

import { User } from "../types/BaseInterfaces";

class UsersRepository {
  static readonly baseUrl = "/api/users";

  static async viewedDemoModal({ currentUser }: { currentUser: User }): Promise<void> {
    try {
      await ajax.put(`${this.baseUrl}/${currentUser.id}`, {
        user: {
          has_seen_demo_modal: true,
        }
      })
    } catch (error) {
      console.log(error)
    }
  }
}

export default UsersRepository;
