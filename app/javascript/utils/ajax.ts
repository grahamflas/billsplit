import axios from "axios";
// import axiosRetry from 'axios-retry';
import type { AxiosRequestConfig, AxiosResponse } from "axios";

/*
 * Only retry GET/HEAD/OPTIONS requests (safe)
 * [NOTE] axios-retry will retry PUT and DELETE requests by default since they
 * are expected guaranteed to be idempotent. This retryCondition updates the
 * requests to not re-fire for idemoptent but not safe requests
 */
// axiosRetry(axios, {
//   retries: 3,
//   retryCondition: axiosRetry.isSafeRequestError,
//   // NOTE: This function returns the number of milliseconds that each retry
//   // should be delayed after the previous retry.
//   retryDelay: (retryCount) => retryCount ** 2 * 750,
// });

export default {
  get(url: string, config?: AxiosRequestConfig): Promise<AxiosResponse<any>> {
    return axios.get(url, this.injectRequestHeaders(config));
  },

  getGeneric<T>(
    url: string,
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<T>> {
    return axios.get<T>(url, this.injectRequestHeaders(config));
  },

  post(
    url: string,
    data?: {},
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<any>> {
    return axios.post(url, data, this.injectRequestHeaders(config));
  },

  postGeneric<T>(
    url: string,
    data?: {},
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<T>> {
    return axios.post<T>(url, data, this.injectRequestHeaders(config));
  },

  put(
    url: string,
    data?: {},
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<any>> {
    return axios.put(url, data, this.injectRequestHeaders(config));
  },

  putGeneric<T>(
    url: string,
    data?: {},
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<T>> {
    return axios.put<T>(url, data, this.injectRequestHeaders(config));
  },

  delete(
    url: string,
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<any>> {
    return axios.delete(url, this.injectRequestHeaders(config));
  },

  deleteGeneric<T>(
    url: string,
    config?: AxiosRequestConfig
  ): Promise<AxiosResponse<T>> {
    return axios.delete<T>(url, this.injectRequestHeaders(config));
  },

  authenticityToken(): string {
    const token: Element | null = document.querySelector(
      'meta[name="csrf-token"]'
    );

    if (token && token instanceof window.HTMLMetaElement) {
      return token.content;
    }

    return "";
  },

  injectRequestHeaders(
    config: AxiosRequestConfig | undefined
  ): AxiosRequestConfig {
    return {
      ...(config || axios.defaults),
      headers: {
        "X-CSRF-Token": this.authenticityToken(),
        "X-Requested-With": "XMLHttpRequest",
      },
    };
  },
};
