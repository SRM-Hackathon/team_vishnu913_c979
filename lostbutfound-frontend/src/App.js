import React from 'react'
import './App.css'

import Topnav from './components/main/Topnav'
import { useEffect } from 'react'

import 'materialize-css/dist/css/materialize.min.css'
import M from 'materialize-css/dist/js/materialize.min.js'
import 'material-icons'

import { Logincard } from './components/Auth/Logincard'
import { Registercard } from './components/Auth/Registercard'

import { Route, Switch } from 'react-router-dom'

import AuthState from './context/Auth/AuthState'
import setAuthToken from './utils/setAuthToken'

import PrivateRoute from './components/routing/PrivateRoute'
import Addpost from './components/posts/Addpost'
import Addfound from './components/posts/Addfound'
import Switchtab from './components/posts/Switchtab'

if (localStorage.token) {
	setAuthToken(localStorage.token)
}

const App = () => {
	useEffect(() => {
		M.AutoInit()
	})
	return (
		<>
			<AuthState>
				<Topnav />

				<section className='background'>
					<Switch>
						<Route path='/' exact component={Logincard} />
						<Route path='/login' exact component={Logincard} />
						<Route path='/register' exact component={Registercard} />
						
						<PrivateRoute path='/addlost' exact component={Addpost} />
						<PrivateRoute path='/addfound' exact component={Addfound} />
						<PrivateRoute path='/myposts' exact component={Switchtab} />
					</Switch>
				</section>
			</AuthState>
		</>
	)
}

export default App
