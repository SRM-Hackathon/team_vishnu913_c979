import React, { useEffect, useState } from 'react'
import { Link, Route } from 'react-router-dom'
import { Tabs, Tab } from 'react-materialize'
import Listinfo from './Listinfo'

const Switchtab = () => {
	const [fstate, setfstate] = useState([
		{
			name: '',
			email: '',
			phone_no: '',
			description: '',
			img: '',
			location: '',
			latitude: '',
			longitude: '',
			date_lost: ''
		}
	])
	const [lstate, setlstate] = useState([
		{
			name: '',
			email: '',
			phone_no: '',
			description: '',
			img: '',
			location: '',
			latitude: '',
			longitude: '',
			date_lost: ''
		}
	])

	useEffect(() => {
		fetch('http://192.168.43.46:8000/genfound', {
			method: 'get',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
				Authorization: localStorage.getItem('token').trim()
			}
		})
			.then(result => {
				return result.json()
			})
			.then(res => {
				setfstate(res)
				console.log(res)
			})

		fetch('http://192.168.43.46:8000/genlost', {
			method: 'get',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
				Authorization: localStorage.getItem('token').trim()
			}
		})
			.then(result => {
				return result.json()
			})
			.then(res => {
				setlstate(res)
				console.log(res)
			})
	}, [])

	return (
		<div className='container' style={{ paddingTop: '10px' }}>
			<Tabs className='tab-demo z-depth-1 tabs-fixed-width'>
				<Tab title='LOST' active>
					{lstate.map(e => (
						<div
							className='col s6 '
							style={{ width: '50%', paddingTop: '50px' }}
						>
							<div className='card' style={{ width: '60%', margin: 'auto' }}>
								<div className='card-image waves-effect waves-block waves-light'>
									<img
										className='activator'
										src={'http://192.168.43.46:8000' + e.img}
										alt='haha'
									/>
								</div>
								<div className='card-content'>
									<span className='card-title activator grey-text text-darken-4'>
										Person Name:{e.name}
										<i className='material-icons right'>more_vert</i>
									</span>
									<p>
										<a href='/'>This is a link</a>
									</p>
								</div>
								<div className='card-reveal'>
									<span className='card-title grey-text text-darken-4'>
										<b>Person Name: {e.name}</b>
										<i className='material-icons right'>close</i>
									</span>

									<ul className='collection with-header'>
										<li className='collection-item'>Email: {e.email}</li>
										<li className='collection-item'>Phone No: {e.phone_no}</li>
										<li className='collection-item'>
											Description: {e.desciption}
										</li>
										<li className='collection-item'>Location: {e.location}</li>
										<li className='collection-item'>DateLost: {e.date_lost}</li>
									</ul>
								</div>
							</div>
						</div>
					))}
				</Tab>

				<Tab title='FOUND'>
					{fstate.map(e => (
						<div
							className='col s6 '
							style={{ width: '50%', paddingTop: '50px' }}
						>
							<div className='card' style={{ width: '60%', margin: 'auto' }}>
								<div className='card-image waves-effect waves-block waves-light'>
									<img
										className='activator'
										src={'http://192.168.43.46:8000' + e.img}
										alt='haha'
									/>
								</div>
								<div className='card-content'>
									<span className='card-title activator grey-text text-darken-4'>
										Person Name:{e.name}
										<i className='material-icons right'>more_vert</i>
									</span>
									<p>
										<a href='/'>This is a link</a>
									</p>
								</div>
								<div className='card-reveal'>
									<span className='card-title grey-text text-darken-4'>
										<b>Person Name: {e.name}</b>
										<i className='material-icons right'>close</i>
									</span>

									<ul className='collection with-header'>
										<li className='collection-item'>Email: {e.email}</li>
										<li className='collection-item'>Phone No: {e.phone_no}</li>
										<li className='collection-item'>
											Description: {e.desciption}
										</li>
										<li className='collection-item'>Location: {e.location}</li>
										<li className='collection-item'>DateLost: {e.date_lost}</li>
									</ul>
								</div>
							</div>
						</div>
					))}
				</Tab>
			</Tabs>
		</div>
	)
}

export default Switchtab
