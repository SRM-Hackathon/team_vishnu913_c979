import React, { useState, useEffect } from 'react'
import { Map, GoogleApiWrapper, Marker } from 'google-maps-react'

import Geosuggest from 'react-geosuggest'

const Mymap = (props) => {
    const [state, setstate] = useState({
        lat: '',
        lng: ''
    })

    const { fstate, setfstate } = props.data
    
    const locState = {
        lat: fstate.lat, lng: fstate.lng
    }

    useEffect(() => {
        navigator.geolocation.getCurrentPosition(position => {
            const { latitude, longitude } = position.coords

            console.log(latitude, longitude)
            setfstate({...fstate, lat: latitude, lng: longitude })
        })
    }, [])

    const mapStyles = {
        width: '60%',
        height: '60vh',
        margin: 'auto'
    }

    const [sname, setsname] = useState('')

    const onMarkerDragEnd = coord => {
        //console.log(index)
        const { latLng } = coord
        const lat = latLng.lat()
        const lng = latLng.lng()

        console.log(lat, lng)
        setfstate({
            ...fstate,
            lat,
            lng
        })
    }

    const onschange = value => {
   
        setsname(value)
    }

    const mapClicked = (mapProps, map, clickEvent) => {
        const lat = clickEvent.latLng.lat()
        const lng = clickEvent.latLng.lng()

        setfstate({ ...fstate,lat, lng })
    }

    const showRes = e => {
        if (e) setfstate({ ...fstate,lat: e.location.lat, lng: e.location.lng })
    }

    return (
        <>
            <Geosuggest
                value={sname}
                onChange={onschange}
                onSuggestSelect={showRes}
            />

            <Map
                google={props.google}
                zoom={15}
                style={mapStyles}
                center={locState}
                initialCenter={locState}
                onClick={mapClicked}
            >
                <Marker
                    position={locState}
                    draggable={true}
                    onDragend={(t, map, coord) => onMarkerDragEnd(coord)}
                />
            </Map>
        </>
    )
}

export default GoogleApiWrapper({
    apiKey: 'AIzaSyBRMxmWyTA2yeYIA6kh6aUWIKBPR6Xm8mw'
})(Mymap)
