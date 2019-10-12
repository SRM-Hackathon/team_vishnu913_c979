import React, { useReducer } from 'react'

import AuthContext from './authContext'
import authReducer from './authReducer'
import setAuthToken from '../../utils/setAuthToken'

import {
	REGISTER_SUCCESS,
	REGISTER_FAIL,
	USER_LOADED,
	LOGIN_SUCCESS,
	LOGIN_FAIL,
	LOGOUT,
	CLEAR_ERRORS
} from '../types'

const AuthState = props => {
	const initialState = {
		token: localStorage.getItem('token'),
		isAuthenticated: null,
		isCreated: null,
		
		error: null
	}

	const [state, dispatch] = useReducer(authReducer, initialState)

	// Load User
	const loaduser = async () => {
		if (localStorage.token) {
			setAuthToken(localStorage.token)

			dispatch({
				type: USER_LOADED,
				payload: localStorage.token
			})
		}
	}

	// Register User
	const register = async formData => {
		try {
			console.log(formData)
			const { email, username, phone_number, password } = formData

			const response = await fetch('http://192.168.43.46:8000/register/', {
				method: 'POST',
				body: new URLSearchParams(
					`email=${email}&password=${password}&phone_number=${phone_number}&username=${username}`
				),
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded'
				}
			})
			// const res = await response.json()

			dispatch({
				type: REGISTER_SUCCESS
			})

			loaduser()
		} catch (err) {
			dispatch({
				type: REGISTER_FAIL,
				payload: err
			})
			console.log(err)
		}
	}

	// Login User
	const login = async formData => {
	

		const { email, password } = formData

		try {
			const response = await fetch('http://192.168.43.46:8000/login/', {
				method: 'POST',
				body: new URLSearchParams(`email=${email}&password=${password}`),
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				}
			})
			const res = await response.json()

			console.log(res)

			dispatch({
				type: LOGIN_SUCCESS,
				payload: res.token
			})

			loaduser()
		} catch (err) {
			dispatch({
				type: LOGIN_FAIL,
				payload: err
			})
		}
	}

	// Logout
	const logout = () => dispatch({ type: LOGOUT })

	// Clear Errors
	const clearErrors = () => dispatch({ type: CLEAR_ERRORS })

	return (
		<AuthContext.Provider
			value={{
				token: state.token,
				isAuthenticated: state.isAuthenticated,
				
				user: state.user,
				error: state.error,
				register,
				isCreated: state.isCreated,
				login,
				logout,
				clearErrors,
				loaduser
			}}
		>
			{props.children}
		</AuthContext.Provider>
	)
}

export default AuthState
