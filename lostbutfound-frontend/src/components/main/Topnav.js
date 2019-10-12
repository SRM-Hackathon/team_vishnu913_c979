import React, { useContext, useEffect } from 'react'
import { Link } from 'react-router-dom'
import AuthContext from '../../context/Auth/authContext'

const Topnav = props => {
	const authContext = useContext(AuthContext)
	const { logout, isAuthenticated, loaduser } = authContext

	const onLogout = () => {
		logout()
	}

	const guestlink = (
		<>
			<li>
				<Link to='/login'>login</Link>
			</li>
			<li>
				<Link to='/register'>register</Link>
			</li>
		</>
	)

	const userlink = (
		<>
			<li>
				<Link to='/myposts'>my posts</Link>
			</li>

			<li>
				<Link to='/addlost'>Add lost</Link>
			</li>

			<li>
				<Link to='/addfound'>Add found</Link>
			</li>
			<li>
				<Link to='/login' onClick={onLogout}>
					logout
				</Link>
			</li>
		</>
	)
	useEffect(() => {
		loaduser()
		// eslint-disable-next-line
	}, [])

	return (
		<nav>
			<div className='nav-wrapper purple darken-4'>
				<ul id='nav' className='left'>
					<li>
						<Link id='logo' to='/'>
							lostbutfound
						</Link>
					</li>
				</ul>

				<ul id='nav' className='right'>
					{isAuthenticated ? userlink : guestlink}
				</ul>
			</div>
		</nav>
	)
}

export default Topnav
