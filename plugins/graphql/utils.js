'use strict';

const semver = require('semver');

module.exports = {
	getVersion: VERSION => {
		const MAJOR = semver.major(VERSION);
		const MINOR = semver.minor(VERSION);

		return `v${MAJOR}.${MINOR}`;
	}
};